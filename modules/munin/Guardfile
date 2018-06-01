notification :off

guard 'rake', :task => 'test' do
  watch('Rakefile')
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^templates\/(.+)\.erb$})
end

guard 'rake', :task => 'metadata' do
  watch('metadata.json')
end
