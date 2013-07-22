killall new_datamap_tests.sh
killall testoob
echo "\n\n KILLED by stop_tests.sh at `date`" > `ls -1t ~/env/dm/log/test_output/*test.out | head -n1`
