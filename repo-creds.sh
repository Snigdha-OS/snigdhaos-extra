sudo pacman-key --recv-key 1CC586C7A25E47C5 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 1CC586C7A25E47C5
pacman -U '#'
pacman -U '@'
