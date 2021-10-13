(NF == 3) {
    tests[$1]++;
    metrics[$1, $2] = $3;
}

END {
    print "{ \"results\": ["
    nb_tests = length(tests)
    for (test in tests) {
        nb_metrics = tests[test]
        print "  { \"name\": \"" test "\","
        print "    \"metrics\": {"
        for (key in metrics) {
            if (index(key, test) != 1)
                continue;
            n = length(test)
            metric = substr(key, n + 1, length(key) - n)
            count = metrics[key]
            --nb_metrics
            comma = nb_metrics > 0 ? "," : ""
            print "      \"" metric "\": " count comma
        }
        --nb_tests
        comma = nb_tests > 0 ? "," : ""
        print "    }"
        print "  }" comma
    }
    print "]}"
}
