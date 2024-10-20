#!/bin/bash

echo "Es wird ein Update auf das SealedSecret gemacht."
echo "Das SealedSecret wird dann wiederum zum secret alertmanager-main."
echo "Wenn ArgoCD Auto Sync ein ist, wird das überschrieben."

filename="alertmanager.yml"

if [ ! -e ${filename} ];
then
  echo "ERROR: Es gibt keine Datei ${filename}"
  exit 1
fi

echo -e "\nACHTUNG: Du verwendest gerade: $(oc whoami --show-server=true)\n"

SEALED_SECRET=$(oc create secret generic alertmanager-main --from-file=alertmanager.yaml=alertmanager.yml --dry-run=client -o yaml -n openshift-monitoring | kubeseal -o yaml --cert <(kubeseal --fetch-cert --controller-name sealed-secrets-operator --controller-namespace gp-infrastructure))
echo $SEALED_SECRET | oc -n openshift-monitoring apply -f -
