task :doc do
  `rm -rf doc && mkdir -p doc && cp -R ../alf-doc/compiled/man doc && cp -R ../alf-doc/compiled/txt doc`
end