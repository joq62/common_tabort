all:
	rm -rf  *~ */*~ apps/config/src/*.beam apps/config/src/*~ test/*.beam erl_cra*;
	rm -rf  logs *.service_dir rebar.lock;
	rm -rf cluster1;
	rm -rf _build test_ebin ebin deployments *_info_specs;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;
	echo Done
check:
	rebar3 check

eunit:
	rm -rf  *~ */*~ apps/config/src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.service_dir deployments *_info_specs;
	rm -rf rebar.lock;
	rm -rf ebin test_ebin cluster1;
	mkdir cluster1;
	mkdir  cluster1/application_info_specs;
	cp ../../specifications/application_info_specs/*.spec cluster1/application_info_specs;
	mkdir  cluster1/host_info_specs;
	cp ../../specifications/host_info_specs/*.host cluster1/host_info_specs;
	mkdir cluster1/deployment_info_specs;
	cp ../../specifications/deployment_info_specs/*.depl cluster1/deployment_info_specs;
	mkdir cluster1/deployments;
	cp ../../specifications/deployments/*.depl_spec cluster1/deployments;
	rebar3 compile;
	mkdir test_ebin;
	mkdir ebin;
	cp _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa * -pa ebin -pa test_ebin -sname config -run basic_eunit start -setcookie cookie_test
