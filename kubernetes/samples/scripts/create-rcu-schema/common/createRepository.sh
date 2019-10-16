#!/bin/bash
# Copyright (c) 2019, Oracle Corporation and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

. /u01/oracle/wlserver/server/bin/setWLSEnv.sh

echo "Check if the DB Service is ready to accept request "
connectString=${1:-oracle-db.default.svc.cluster.local:1521/devpdb.k8s}
schemaPrefix=${2:-domain1}
rcuType=${3:-fmw}

echo "DB Connection String [$connectString], schemaPrefix [${schemaPrefix}] rcuType [${rcuType}]"

max=20
counter=0
while [ $counter -le ${max} ]
do
 java utils.dbping ORACLE_THIN scott tiger ${connectString} > dbping.err 2>&1
 [[ $? == 0 ]] && break;
 ((counter++))
 echo "[$counter/${max}] Retrying the DB Connection ..."
 sleep 10
done

if [ $counter -gt ${max} ]; then
 echo "[ERROR] Oracle DB Service is not ready after [${max}] iterations ..."
 exit -1
else
 java utils.dbping ORACLE_THIN scott tiger ${connectString}
fi

# SOA needs extra component(s) SOAINFRA and ESS
# SOA needs variables param(s) SOA_PROFILE_TYPE=SMALL,HEALTHCARE_INTEGRATION=NO

extComponents=""
extVariables=""
if [ "x$rcuType" == "xsoa" ]; then
  extComponents="-component SOAINFRA -component ESS"
  extVariables="-variables SOA_PROFILE_TYPE=SMALL,HEALTHCARE_INTEGRATION=NO"
  echo "Creating RCU Schema for SOA Infra .."
fi

#Debug 
#export DISPLAY=0.0
#/u01/oracle/oracle_common/bin/rcu -listComponents

/u01/oracle/oracle_common/bin/rcu -silent -createRepository \
 -databaseType ORACLE -connectString ${connectString} \
 -dbUser sys  -dbRole sysdba -useSamePasswordForAllSchemaUsers true \
 -selectDependentsForComponents true \
 -schemaPrefix ${schemaPrefix} ${extComponents} ${extVariables} \
 -component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER \
 -component OPSS -component WLS -component STB  < /u01/oracle/pwd.txt