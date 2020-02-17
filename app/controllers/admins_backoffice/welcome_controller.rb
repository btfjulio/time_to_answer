class AdminsBackoffice::WelcomeController < AdminsBackofficeController
  def index
    @total_questions = AdminStatistic.search_statistic(:total_questions)
    @total_users = AdminStatistic.search_statistic(:total_users)
  end
end
