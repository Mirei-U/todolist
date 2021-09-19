//
//  ViewController.swift
//  TodoList
//
//  Created by 内田光玲 on 2021/06/23.
//

import UIKit

class TableViewController: UITableViewController {
    //TodoListに書いた文章を配列で定義
    var todoText = [String]()
    //TodoListのチェックマークをBool型の配列で定義
    var todoCheck = [Bool]()
    
    override func viewDidLoad() {//アプリを開始するタイミングで実行される
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        todoText.append("宿題をやる")
//        todoCheck.append(false)//todoTextに要素を追加するたびにtodoCheckにもfalseという値を追加
//        todoText.append("Youtubeを見る")
//        todoCheck.append(false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didTapAddItemButton(_:)))
        //↑教材は(_sender:)ではなく(_)だけどエラーで続けるから放置
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.green
        
        //UserDefaultsに保存したデータを取得する(テキスト内容)
        if UserDefaults.standard.object(forKey: "TodoText") != nil {
            todoText = UserDefaults.standard.object(forKey: "TodoText") as! [String]
        }
        //UserDefaultsに保存したデータを取得する(チェック情報)
        if UserDefaults.standard.object(forKey: "TodoCheck") != nil {
            todoCheck = UserDefaults.standard.object(forKey: "TodoCheck") as! [Bool]
        }
    }

    //せるの数を設定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoText.count
    }
    //セクションの設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //せるの内容を設定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TodoCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        TodoCell.textLabel!.text = todoText[indexPath.row]
        
        let accessory: UITableViewCell.AccessoryType = todoCheck[indexPath.row] ? .checkmark: .none
        TodoCell.accessoryType = accessory
        
        return TodoCell
    }
    //チェックマークをつける
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todoCheck[indexPath.row] = !todoCheck[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //UserDefaultsにデータを保存する(チェック情報)ここにも必要！
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
    //アクションシートを使用.  _ senderスペース忘れずに
    @objc func didTapAddItemButton(_ sender:UIBarButtonItem) {
        let alert=UIAlertController(
            title: "追加する項目",
            message: "ToDoリストに新しい内容を追加します",
            preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_)in
            if let title = alert.textFields?[0].text
            {
                if title == "" {//もし入力されていなかったら
                    let al = UIAlertController(
                        title: "エラー", message: "テキストを入力してください" , preferredStyle: .alert)
                    al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(al, animated: true, completion: nil)
                }else{
                self.addNewToDoItem(title: title)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //テキストを追加する
    func addNewToDoItem(title: String){
        let newIndex = todoText.count
        todoText.append(title)
        todoCheck.append(false)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        //UserDefaultsにデータを保存する(テキスト内容)
        UserDefaults.standard.set(todoText, forKey: "TodoText")
        //UserDefaultsにデータを保存する(チェック情報)
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
    
    //セルを消去
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoText.remove(at: indexPath.row)
        todoCheck.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        //UserDefaultsにデータを保存する
        UserDefaults.standard.set(todoText,forKey: "TodoText")
//        UserDefaultsにデータを保存する(チェック情報)
        UserDefaults.standard.set(todoCheck, forKey: "TodoCheck")
    }
}
