module UsersBackoffice::ProfileHelper
    def gender_select(user, gender)
        user.user_profile.gender == gender ? "btn-primary" : "btn-default"
    end

    def avatar_url(current_user)
        avatar = current_user.user_profile.avatar 
        avatar.attached? ? avatar : 'img.jpg'  
    end
end
