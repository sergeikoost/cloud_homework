### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).


### **Ответ**


#### Первый раз все сделал вручную, как на вебинаре, после создал манифесты для Terraform которые будут в директории src в данном репозитории

#### Скриншнот с созданными вм:

<img width="1852" height="189" alt="homework_1" src="https://github.com/user-attachments/assets/5fa1e2ce-75c3-41ba-8ccc-7072e1ef0aaf" />


#### Public vm:

<img width="713" height="401" alt="homework_1 1" src="https://github.com/user-attachments/assets/2d03e88c-5b9b-4f9e-bfb4-933bf2fc32c6" />


#### Private vm:

<img width="757" height="389" alt="homework_1 2" src="https://github.com/user-attachments/assets/4e0564ea-6c22-4623-8f87-9ee8aebbbe3b" />
