all:
	rm -rf  *~ */*~  src/*.beam test/*.beam erl_cra*;
	rm -rf  Mnesia.* host_specs deployment_specs logs *.service_dir;
	rm -rf _build test_ebin ebin rebar.lock;		
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs;
	git add -f *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
check:
	rebar3 check
eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs *.service_dir;
	rm -rf  catalog host_specs deployment_specs;
	rm -rf ebin  rebar.lock;
	mkdir test_ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa ebin -pa test_ebin\
	    -pa /home/joq62/erlang/infra_2/config/ebin\
            -pa /home/joq62/erlang/*\
            -sname common_test -run $(m) start -setcookie cookie_test
