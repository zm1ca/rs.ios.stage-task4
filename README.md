[Разбор решений](https://youtu.be/0x_wTWzc4j8)

# Тask 4
Task 4 состоит из 3 подзадач, которые вам необходимо выполнить. 
Все задачи находятся в корне проекта в папке Exercises

## Детали по каждой задаче вы сможете найти в ниже представленных файлах:
  - IntToRoman.md
  - FillWithColor.md
  - CallStation.md

## Описание 
Каждая задача состоит из .swift файлов, давайте рассмотрим третье задание
в папке /Exercises-3 вы найдете пять файлов:
- CallStation.md — условие
- Call.swift — базовые протоколы для звонка
- User.swift — структура пользователя
- Station.swift — базовый протокол для станции
- CallStation.swift — класс, который поддерживает протокол Station. Именного его надо реализовать


В файле CallStation.swift вы сможете найти методы протокола Station
```
extension CallStation: Station {
    func users() -> [User] {
        []
    }
    
    func add(user: User) {

    }
    
    func remove(user: User) {

    }
    
    func execute(action: CallAction) -> CallID? {
        nil
    }
    
    func calls() -> [Call] {
        []
    }
    
    func calls(user: User) -> [Call] {
        []
    }
    
    func call(id: CallID) -> Call? {
        nil
    }
    
    func currentCall(user: User) -> Call? {
        nil
    }
}
```
 в которые вам надо будет написать код, для решения поставленной задачи. 
 Сама задача описана в CallStation.md. 

 Для того, чтобы проверить верно ли вы решили 
 задачу, вам необходимо будет запустить тесты. Для того чтобы запустить тесты необходимо 
 выбрать любой доступный симулятор и нажать ⌘U или через меню Product->Test

после того как все отработает вы сможете увидеть детали выполнения по каждой из задач. 
Если ваше решение верно то тесты отобразятся с зеленым маркером если нет то красным. 

Если все задачи решены и тесты с зеленым маркером то возрадуйтесь, можно бежать и нажать волшебную кнопку Submit.

Все тесты находятся в таргете ios.stage-taskTests в папке ios.stage-taskTests

Если вы пришли к выводу, что выполнили максимум того что могли сделать, то сделайте Submit задачи через 
https://app.rs.school/
