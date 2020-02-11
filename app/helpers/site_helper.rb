module SiteHelper
    def msg_jumbotrom
        case params[:action]
        when 'index'
            'Últimas perguntas cadastradas'
        when 'questions'
            "Resultados para  o termo \"#{params[:term]}\""
        when 'subjects'
            "Mostrando questões para o assunto \"#{params[:subject]}\""
        end
    end 
end
