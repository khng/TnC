project_file_name = 'Test\ Project.xcodeproj/project.pbxproj'
replacement_file_names = ['/Users/targetAttributes', '/Users/baseConfigDebug', '/Users/baseConfigRelease']

text = File.read(project_file_name)

target_attribute_replacement_text = File.read(replacement_file_names[0])
new_contents = text.gsub(/TargetAttributes = {[^}]*}[^}]*}[^}]*};/, target_attribute_replacement_text)

base_config_debug_replacement_text = File.read(replacement_file_names[1])
new_contents = new_contents.gsub(/baseConfigurationReference = 9F13DD80C92DE4C35DEE7598 \/\* Pods-Test Project.debug.xcconfig \*\/;[^{]*{[^}]*};/, base_config_debug_replacement_text)

base_config_release_replacement_text = File.read(replacement_file_names[2])
new_contents = new_contents.gsub(/baseConfigurationReference = 6A637C845E30CBD7F5E75F9A \/\* Pods-Test Project.release.xcconfig \*\/;[^{]*{[^}]*};/, base_config_release_replacement_text)

# To merely print the contents of the file, use:
puts new_contents

# To write changes to the file, use:
File.open(project_file_name, "w") {|file| file.puts new_contents }