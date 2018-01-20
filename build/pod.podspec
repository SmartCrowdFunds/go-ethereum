Pod::Spec.new do |spec|
  spec.name         = 'Geth'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/SmartCrowdFunds/smartcrowdfunds-blockchain'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Ethereum Client'
  spec.source       = { :git => 'https://github.com/SmartCrowdFunds/smartcrowdfunds-blockchain.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/Geth.framework'

	spec.prepare_command = <<-CMD
    curl https://gscfstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/Geth.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
