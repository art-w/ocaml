(NF == 3) {
    key = $1 $2
    if (key in metrics) {
        multiple[key]++;
        metrics[key] = metrics[key] "," $3;
    } else {
        metrics[key] = $3;
        tests[$1]++;
    }
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
            measurements = metrics[key]
            if (key in multiple)
                measurements = "[" measurements "]"
            --nb_metrics
            comma = nb_metrics > 0 ? "," : ""
            print "      \"" metric "\": " measurements comma
        }
        --nb_tests
        comma = nb_tests > 0 ? "," : ""
        print "    }"
        print "  }" comma
    }
    print "]}"
}
