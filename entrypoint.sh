#!/bin/sh
fun_ss_server()
{
    echo "ss_server"
    ss-server -s $SS_SERVER_HOST -p $SS_SERVER_PORT -k $SS_PASSWORD -m $SS_METHOD -t $SS_TIMEOUT -d $DNS_ADDRS -u
}
fun_goquiet_server()
{
    echo "goquiet_server"
    echo -e "{\n\
        \"WebServerAddr\":\"$GQ_WEBSERVER_ADDRESS\",\n\
        \"Key\":\"$GQ_KEY\",\n\
        \"FastOpen\":$GQ_FAST_OPEN\n\
        }"\
        > /etc/goquiet/gqserver.json
    gq-server -s $GQ_SERVER_HOST -p $GQ_SERVER_PORT -r "$SS_SERVER_ADDRESS:$SS_SERVER_PORT" -c /etc/goquiet/gqserver.json
}

fun_ss_server_with_goquiet()
{
    echo "ss_server_with_goquiet"
    echo -e "{\n\
        \"WebServerAddr\":\"$GQ_WEBSERVER_ADDRESS\",\n\
        \"Key\":\"$GQ_KEY\",\n\
        \"FastOpen\":$GQ_FAST_OPEN\n\
        }"\
        > /etc/goquiet/gqserver.json
    ss-server -p $SS_SERVER_PORT -k $SS_PASSWORD -m $SS_METHOD -t $SS_TIMEOUT -d $DNS_ADDRS -u --plugin /usr/local/bin/gq-server --plugin-opts "/etc/goquiet/gqserver.json"
}

fun_ss_client()
{
    echo "ss_client"
    ss-local -s $SS_SERVER_ADDRESS -p $SS_SERVER_PORT -b $SS_LOCAL_ADDRESS -l $SS_LOCAL_PORT -k $SS_PASSWORD -m $SS_METHOD -t $SS_TIMEOUT -u
}
fun_goquiet_client()
{
    echo "goquiet_client"
    echo -e "{\n\
        \"ServerName\":\"$GQ_SERVER_NAME\",\n\
        \"TicketTimeHint\":$GQ_TICKET_TIME_HINT,\n\
        \"Browser\":\"$GQ_BROWSER\",\n\
        \"Key\":\"$GQ_KEY\",\n\
        \"FastOpen\":$GQ_FAST_OPEN\n\
        }"\
        > /etc/goquiet/gqclient.json
    /usr/local/bin/gq-client -b $GQ_LOCAL_HOST -l $GQ_LOCAL_PORT -s $GQ_SERVER_ADDRESS -p $GQ_SERVER_PORT -c /etc/goquiet/gqclient.json
}
fun_ss_client_with_goquiet()
{
    echo "ss_client_with_goquiet"
    echo -e "{\n\
        \"ServerName\":\"$GQ_SERVER_NAME\",\n\
        \"TicketTimeHint\":$GQ_TICKET_TIME_HINT,\n\
        \"Browser\":\"$GQ_BROWSER\",\n\
        \"Key\":\"$GQ_KEY\",\n\
        \"FastOpen\":$GQ_FAST_OPEN\n\
        }"\
        > /etc/goquiet/gqclient.json
    ss-local -s $GQ_SERVER_ADDRESS -p $GQ_SERVER_PORT -b $SS_LOCAL_ADDRESS -l $SS_LOCAL_PORT -k $SS_PASSWORD -m $SS_METHOD -t $SS_TIMEOUT -u --plugin /usr/local/bin/gq-client --plugin-opts "/etc/goquiet/gqclient.json" 
}

if [ "$OPT_TYPE" = "SS_SERVER" ]
then
    fun_ss_server
fi
if [ "$OPT_TYPE" = "GOQUIET_SERVER" ]
then
    fun_goquiet_server
fi
if [ "$OPT_TYPE" = "SS_SERVER_WITH_GOQUIET" ]
then
    fun_ss_server_with_goquiet
fi
if [ "$OPT_TYPE" = "SS_CLIENT" ]
then
    fun_ss_client
fi
if [ "$OPT_TYPE" = "GOQUIET_CLIENT" ]
then
    fun_goquiet_client
fi
if [ "$OPT_TYPE" = "SS_CLIENT_WITH_GOQUIET" ]
then
    fun_ss_client_with_goquiet
fi

