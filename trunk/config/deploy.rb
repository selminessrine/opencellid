set :user, 'tomsoft'
set :server, 'www.opencellid.org'
set :application, "OpenCellId" 
set :repository, "http://opencellid.googlecode.com/svn/trunk/" 
# le nom de votre user SVN
#set :svn_user, ENV['svn_user'] || "thomas.landspurg"
#set :svn_password, Proc.new { Capistrano::CLI.password_prompt('SVN Password: ') }


role :web, server
role :app, server
role :db,  server, :primary => true

set :deploy_to, "/home/#{user}/#{application}" 

#############################
## Liste de tâches à exécuter 
#############################

#Tâche 1
#Réalisée après la création des liens symboliques necessaires.
task :after_symlink, :roles => [:web, :app] do
    # Changer l'environnement de développement à production
    run "perl -i -pe \"s/# ENV\\['RAILS_ENV'\\] \\|\\|= 'production'/ENV['RAILS_ENV'] ||= 'production'/\" #{current_path}//environment.rb"

    # Renomer le fichier database.yml.prd 
    #run "cp #{current_path}/config/database.yml.prd #{current_path}/config/database.yml"
    cp #{current_path}/../shared/database.yml #{current_path}/config/database.yml"
	
    # Conserver le même répertoire tmp qu'avant le déploiement, création de liens sympliques
    run "rm -drf #{current_path}/tmp"
    run "ln -s #{shared_path}/tmp #{current_path}/tmp"
end

#Tâche 2
#Exemple d'une tâche qui fait en sorte de conserver les même répertoire rep1 et rep2 avant et après déploiement
#Utile pour un répertoire d'images uploadées par exemple.
# task :after_update_code do
#  %w{rep1 rep2}.each do |share|
#  run "rm -drf #{release_path}/public/#{share}"
#    run "ln -s #{shared_path}/#{share} #{release_path}/public/#{share}"
#  end
#end
task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end
task :restart, :roles => :app do

end
