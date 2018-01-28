Pod::Spec.new do |spec|
  spec.name         = 'gzmx'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/Zamolxes-ZMX/go-zmx'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Ethereum Client'
  spec.source       = { :git => 'https://github.com/Zamolxes-ZMX/go-zmx.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/gzmx.framework'

	spec.prepare_command = <<-CMD
    curl https://gzmxstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/gzmx.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
