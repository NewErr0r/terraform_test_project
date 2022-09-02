# Создаём локальную сеть
resource "yandex_vpc_network" "local-network" {
  name = "local-network"
  description = "application"
}

# Создаём подсеть в локальной сети
resource "yandex_vpc_subnet" "local-subnet" {
  name           = "local-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.local-network.id
  v4_cidr_blocks = ["192.168.100.0/24"]
}