json.extract! @user, :id, :name, :email, :role
json.job_applications @user.job_applications do |job|
  json.extract! job, :id, :title, :description
end
