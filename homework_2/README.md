## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.


**Ответ**


#### Создать бакет Object Storage и разместить в нём файл с картинкой:

<img width="1310" height="465" alt="image" src="https://github.com/user-attachments/assets/5357206a-ded5-4258-920c-ddbe6064ab53" />

<img width="1163" height="378" alt="homework_2 1-curl" src="https://github.com/user-attachments/assets/59a1aefe-7508-42a6-a0e3-3479886c2df4" />


#### Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

<img width="1087" height="379" alt="homework_2 4" src="https://github.com/user-attachments/assets/584c5787-e059-42e9-9d01-2554250e62e8" />

#### И проверка состояния бакета:

<img width="1348" height="547" alt="homework_2 5" src="https://github.com/user-attachments/assets/6af365ee-09c0-4d3e-ab8f-2dddc61f4a28" />


#### Подключить группу к сетевому балансировщику:

<img width="1012" height="246" alt="homework_2 7-balance" src="https://github.com/user-attachments/assets/248fa502-680a-46d5-9c73-9f4812648739" />

<img width="775" height="576" alt="homework_2 8-balance" src="https://github.com/user-attachments/assets/8ec839be-0fc9-43a4-8e56-512f08689b81" />


#### Удаляем вм:

<img width="1855" height="65" alt="homework_2 9-balance" src="https://github.com/user-attachments/assets/d54a5fc6-bb66-4734-8fa7-b068bd185465" />

#### Балансировщик удаляет из таргетов сразу, создает новую взамен, спустя пару минут система полностью восстанавливается:
<img width="1563" height="233" alt="homework_2 10-balance" src="https://github.com/user-attachments/assets/bcb51fb8-4471-431c-a799-74ebe4990545" />




