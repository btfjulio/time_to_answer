# frozen_string_literal: true

namespace :dev do
  DEFAULT_PASSWORD = 123_456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'temp')

  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando BD...') { `rails db:drop` }
      show_spinner('Criando BD...') { `rails db:create` }
      show_spinner('Migrando BD...') { `rails db:migrate` }
      show_spinner('Cadastrando o administrador padrão...') { `rails dev:add_default_admin` }
      show_spinner('Cadastrando administradores extras...') { `rails dev:add_extra_admin` }
      show_spinner('Cadastrando o usuario padrão...') { `rails dev:add_default_user` }
      show_spinner('Cadastrando o assuntos padrão...') { `rails dev:add_default_subjects` }
      show_spinner('Cadastrando questões e respostas...') { `rails dev:add_answers_and_questions` }
    else
      puts 'Você não está em ambiente de desenvolvimento!'
    end
  end

  desc 'Adiciona o administrador padrão'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Adiciona o administrador extras'
  task add_extra_admin: :environment do
    10.times do
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc 'Adiciona o user padrão'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Adiciona os assuntos padrão'
  task add_default_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc 'Adiciona os questões padrão'
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do
        params = {
          question: create_question_params(subject)
        }
        choose_write_answer(params)
        Question.create!(params[:question])
      end
    end
  end

  desc 'Reseta o contador dos assuntos'
  task reset_subject_counter: :environment do
    show_spinner("Resetando contador dos assuntos...") do
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end
  

  private

  def create_question_params(subject = Subject.all.sample)
    {
      subject: subject,
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      answers_attributes: create_answer_params
    }
  end

  def create_answer_params
    Array(2..rand(3..5)).map do |_|
      {
        description: Faker::Lorem.sentence,
        correct: false
      }
    end
  end

  def choose_write_answer(params)
    answers_array = params[:question][:answers_attributes]
    answers_array[rand(answers_array.size)][:correct] = true
  end

  def show_spinner(msg_start, msg_end = 'Concluído!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
