# Создаём VM app-gw
resource "yandex_compute_instance" "app-gw" {        
    name        = "app-gw"  
    zone        = "ru-central1-a"

    resources {
        cores   = 2                                            
        memory  = 2                                           
    }

    boot_disk {
        initialize_params {
            image_id = "fd8o2rifm2evjvpms578"   # Мой образ с Alma-9 (root:toor серийная консоль)
            size     = 20 #GB
        }
    }

    network_interface {
        subnet_id   = yandex_vpc_subnet.local-subnet.id
        ip_address  = "192.168.100.254"
        nat         = true
    }

    scheduling_policy {
      preemptible = true                        # Прерываемая VM            
    }

    metadata = {
        ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"     # user - логин пользователя
    }
}

# Создаём VM app-vm01 и app-vm02
resource "yandex_compute_instance" "app-vm" {
    count   = 2 
    name    = "app-vm0${count.index+1}"
    zone    = "ru-central1-a"  

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
        initialize_params {
            image_id = "fd8o2rifm2evjvpms578"   # Мой образ с Alma-9 (root:toor серийная консоль)
            size     = 20 #GB
        }
    }

    network_interface {
        subnet_id   = yandex_vpc_subnet.local-subnet.id
        ip_address  = "192.168.100.10${count.index+1}"
        nat         = true
    }

    scheduling_policy {
      preemptible = true                        # Прерываемая VM            
    }

    metadata = {
        ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"     # user - логин пользователя
    }
}

# Выводит внешний IP-адрес VM app-gw
output "external_ip_address_app_gw" {
    value = yandex_compute_instance.app-gw.network_interface.0.nat_ip_address  
}