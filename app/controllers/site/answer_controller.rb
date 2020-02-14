class Site::AnswerController < SiteController
    def question
      puts params
      @answer = Answer.find(params[:answer_id])
      UserStatistic.set_user_statistic(@answer, current_user)
    end

end
  