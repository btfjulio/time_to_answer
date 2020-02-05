class AdminsBackoffice::QuestionsController < AdminsBackofficeController
    before_action :set_question, only: %i[edit update destroy]
    before_action :params_question, only: [:update]
  
    def index
      @questions = Question.all.order(:description).page(params[:page]).per(5)
    end
  
    def new
      @question = Question.new
    end
  
    def create
      @question = Question.new(params_question)
      if @question.save
        redirect_to admins_backoffice_welcome_index_path, notice: 'Pergunta criada com sucesso!'
      else
        render :new
      end
    end
  
    def edit; end
  
    def update
      if @question.update(params_question)
        redirect_to admins_backoffice_questions_path, notice: 'Pergunta atualizada com sucesso!'
      else
        render :edit
      end
    end
  
    def destroy
      if @question.destroy
        redirect_to admins_backoffice_questions_path, notice: 'Pergunta deletada com sucesso!'
      else
        render :index
      end
    end
  
    private
  
    def set_question
      @question = Question.find(params[:id])
    end
  
    def params_question
      params_question = params.require(:question).permit(:description)
    end
  end
  