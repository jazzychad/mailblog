# replace /home/chad with your home directory
# replace s3://mailblog.example.com/ with your s3 bucket

namespace :site do
  task :clean do
    sh 'rm -rf _site'
  end

  task :sass do
    sh 'compass compile'
  end

  task :compile do
   sh '/home/chad/scripts/ruby/gems/jc-jekyll/bin/jekyll'
  end

  task :serve => [:clean, :sass] do
   sh '/home/chad/scripts/ruby/gems/jc-jekyll/bin/jekyll --server'
  end

  task :deploy => [:clean, :sass, :compile] do
  
   puts 'Deploying site...'
   sh 's3cmd --config=/home/chad/.s3cfg_mailblog sync _site/ s3://mailblog.example.com/'
   sh 'rake site:clean'
   puts 'Done.'

  end

end
