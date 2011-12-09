Before do |scenario|
  start_scenario(scenario.title)
  clean_repository()
end


Given /^"([^"]*)" "([^"]*)" exists$/ do | project, version|
  create_project(name: project, version: version)
end


Given /^"([^"]*)" "([^"]*)" depends on "([^"]*)" "([^"]*)"$/ do | project, version, dependency, dependency_version |
  create_project(name: project, version: version).add_dependency(name: dependency, version: dependency_version)
end

Then /^the gradle build for "([^"]*)" "([^"]*)" will include "([^"]*)" "([^"]*)"$/ do | project, version, dependency, dependency_version |
  build_all_projects_except(project: project)

  dependencies_for(project: project, version: version).should include "net.twasink.#{@scenario_name_normalized}:#{dependency.downcase}:#{dependency_version}"
end

Then /^the maven build for "([^"]*)" "([^"]*)" will include "([^"]*)" "([^"]*)"$/ do | project, version, dependency, dependency_version |
  maven_build_all_projects_except(project: project)

  maven_dependencies_for(project: project, version: version).should include "net.twasink.#{@scenario_name_normalized}:#{dependency.downcase}:jar:#{dependency_version}"
end
