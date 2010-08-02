require 'aws/s3'

@settings = YAML.load(ERB.new(File.new(
  File.join(Rails.root, 'config', 's3.yml')).read).result)

def upload_directory(asset)
  puts "indexing all files in: #{asset}"
  Dir.entries(File.join(Rails.root, 'public', asset)).each do |file|
    next if file =~ /\A\./
    if File.directory? File.join(Rails.root, 'public', asset, file)
      upload_directory File.join(asset, file)
    else
      puts "storing #{asset}/#{file}"
      AWS::S3::S3Object.store(
        file,
        open(File.join(Rails.root, 'public', asset, file)),
        File.join(@settings['bucket_name'], asset))
    end
  end
end

namespace :s3 do

  desc "Upload assets to S3"
  task :upload_assets do

    AWS::S3::Base.establish_connection!(
      :access_key_id => @settings['access_key_id'],
      :secret_access_key => @settings['secret_access_key'])    

    objects = AWS::S3::Bucket.objects(@settings['bucket_name'])
    puts "deleting #{objects.size} objects"
    objects.each do |object|
      object.delete
    end

    buckets = AWS::S3::Bucket.objects(@settings['bucket_name'])
    puts "deleting #{buckets.size} buckets"
    buckets.each do |bucket|
      bucket.delete
    end
    
    @settings['assets'].each do |asset|
      puts "asset: #{asset}"
      if asset =~ /\A([^\*]+)\*\Z/
        asset = $1
        asset.gsub!(/\/\Z/,'')
        upload_directory(asset)
      else
        puts "storing #{asset}"
        AWS::S3::S3Object.store(
          asset,
          open(File.join(Rails.root, 'public', asset)),
          @settings['bucket_name'])
      end
    end

    Rake::Task["s3:make_public_readable"].execute

  end

  desc "Make all objects in S3 public_read"
  task :make_public_readable do

    AWS::S3::Base.establish_connection!(
      :access_key_id => @settings['access_key_id'],
      :secret_access_key => @settings['secret_access_key'])    
    
    objects = AWS::S3::Bucket.objects(@settings['bucket_name'])
    puts "found #{objects.size} objects"    
    
    public_grant = AWS::S3::ACL::Grant.grant :public_read
  
    objects.each do |object|
      if not object.acl.grants.include? public_grant
        puts "\"#{object.key}\" does not include public_read"
        object.acl.grants << public_grant
        object.acl(object.acl)
      end
    end
  end
end