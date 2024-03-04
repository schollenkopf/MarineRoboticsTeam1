sudo apt update
sudo apt remove default-jre
sudo apt install openjdk-11-jdk
git clone https://github.com/LSTS/neptus.git
cd neptus
git checkout 38c7f41a9885c6b059f79b38861edb4b7b67511b
./gradlew
