#!/bin/bash
echo "hi"
pods=($(kubectl get pods | awk 'NR>1 {print $1}' ))
for i in ${pods[@]}
do
    status=$(kubectl get pod $i| awk 'NR>1 awk {print $3}')
    if [[ $status != "Running" ]]
    then
        cat << EOF > pod_status.json
        {
            "text": ":rotating_light: *Alert* \n *Pod Name:* _ $i _ \n *Status:* \` $status \` "
        }
EOF
        $($(curl -X POST  -H 'Content-type:application/json' --data @pod_status.json https://hooks.slack.com/services/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 2>/dev/null) 2>/dev/null ) 
    fi
done