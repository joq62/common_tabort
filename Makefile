all:
	rm -rf  *~ */*~ src/*.beam tests/*.beam;
	rm -rf erl_cra*;
	rm -rf tests_ebin;
	rm -rf ebin;
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
	mkdir ebin;
	erlc -I include -o ebin src/*.erl;
	rm -rf tests_ebin;
	rm -rf ebin;
	git add *;
	git commit -m $(m);
	git push;
eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam;
	rm -rf erl_cra*;
	rm -rf tests_ebin;
	rm -rf ebin;
	mkdir tests_ebin;
	erlc -I include -o tests_ebin tests/*.erl;
	mkdir ebin;
	erlc -I include -o ebin src/*.erl;
	erl -pa ebin -pa test_ebin\
            -sname common_test -run $(m) start -setcookie cookie_test
