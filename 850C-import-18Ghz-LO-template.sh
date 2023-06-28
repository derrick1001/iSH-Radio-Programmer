sleep 2
echo "admin"
sleep 2
echo "admin"
sleep 2
echo "platform configuration channel server set ip-address $1 directory sd1/850C-Builds/ filename 850C-12-1-18Ghz-LO-template.zip username RSI-Admin password can0py_BAM"
sleep 3
echo "platform configuration configuration-file import restore-point-1"
sleep 3
echo "yes"
sleep 15
echo "platform configuration configuration-file restore restore-point-1"
sleep 3
echo "yes"
sleep 10

