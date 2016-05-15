# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( dist/* )
Rails.application.config.assets.precompile += %w( fullcalendar.min.css )
Rails.application.config.assets.precompile += %w( fullcalendar.print.css )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/gal_del.png )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/zip.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/xls.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/doc.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/docx.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/odt.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/ods.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/pdf.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/rar.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/tar.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/tar.gz.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/images/thumbs/swf.gif )
