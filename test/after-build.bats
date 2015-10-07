#!/usr/bin/env bats

@test "confirm hostname pretend to work." {
    run service hostname start
    [ $status = 0 ]
}

@test "confirm hwclock pretend to work." {
    run hwclock any-params
    [ $status = 0 ]
}

@test "service postfix could start/stop right." {
    run service postfix stop

    run service postfix start
    [ $status = 0 ]
    [[ $output =~ "Starting postfix  ..." ]]

    run service postfix start
    [ $status = 0 ]
    [[ ${lines[0]} =~ "WARNING: postfix has already been started" ]]

    processNum=$(ps | grep -v grep | grep /usr/lib/postfix/master | wc -l)
    [ $processNum -gt 0 ]

    run netstat -nlt 
    [ $status = 0 ]
    [[ $output =~ ":25 " ]]

    run service postfix stop
    [ $status = 0 ]
    [[ $output =~ "Stopping postfix  ..." ]]

    run service postfix stop
    [ $status = 0 ]
    [[ $output =~ "WARNING: postfix is already stopped" ]]

    # we keep postfix start at the end
    run service postfix start
    [ $status = 0 ]
    [[ $output =~ "Starting postfix  ..." ]]
}