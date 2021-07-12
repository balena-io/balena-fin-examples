echo "Unloading ftdi_sio module..."
modprobe -r ftdi_sio
echo "Unloaded FTDI module"
sleep 3
chmod +x ftdi.sh
echo "Opening screen terminal"
screen -dmS ftdi_program  "./ftdi.sh"
echo "Opened screen terminal"
sleep 5
{ sleep 5; echo "reset"; echo "program firmware/bootloader-storage-internal-ble-combined.s37"; echo "program firmware/soc-example.hex"; echo "reset"; sleep 10; } | telnet localhost 4444
tail -f /dev/null
