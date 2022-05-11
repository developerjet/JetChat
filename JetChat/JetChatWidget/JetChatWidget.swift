//
//  JetChatWidget.swift
//  JetChatWidget
//
//  Created by Jett on 2022/5/7.
//  Copyright © 2022 Jett. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), object: "" , configuration: FYConfigurationIntent())
    }

    func getSnapshot(for configuration: FYConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), object: "",  configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: FYConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, object: "", configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let object: Any
    let configuration: FYConfigurationIntent
}

// 读取最近聊天消息
func readWidgetMsgItem(_ widgetKey: String = "widgetKey", suiteName: String = "group.com.jetchat.2022.JetChatWidget") -> WidgetMsgItem? {
    let userDefaults = UserDefaults(suiteName: suiteName)
    if let object = userDefaults?.object(forKey: widgetKey) {
        // 将objc转成data
        let data: Data = try! JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
        // 将data转成相应模型
        let decoder = JSONDecoder()
        do {
            let msgItem = try decoder.decode(WidgetMsgItem.self, from: data)
            return msgItem
        } catch {
            print("Got error while parsing: \(error)")
            return nil
        }
    }
    return nil
}

//从UserDefault中取值
func simpleModel(_ entryDate: Date) -> SimpleEntry
{
    if let object = readWidgetMsgItem() {
        return SimpleEntry(date: entryDate, object: object, configuration: .init())
    }
    return SimpleEntry(date: entryDate, object: WidgetMsgItem(), configuration: .init())
}

struct JetChatWidgetEntryView : View {
    var entry: Provider.Entry
    
    let msgItem = simpleModel(.now).object as! WidgetMsgItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("最近聊天")
                .foregroundColor(Color.white)
                .lineLimit(4)
                .font(.title3)
                .padding(.horizontal)
            
            Text(msgItem.date)
                .foregroundColor(Color.black)
                .lineLimit(4)
                .font(.title3)
                .padding(.horizontal)
            
            Text("\(msgItem.nickName ?? msgItem.name)：\(msgItem.message)")
                .foregroundColor(Color.white)
                .lineLimit(4)
                .font(.system(size: 14))
                .padding(.horizontal)
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding(5)
            //widget背景图片
            .background(
                Image("icon_widget_bg")
                    .resizable()
                    .scaledToFill()
            ).widgetURL(URL(string: String(format: "https://www.jetchat.com/chatId=%ld", msgItem.chatId ?? -1)))

    }
}

@main
struct JetChatWidget: Widget {
    let kind: String = "JetChatWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: FYConfigurationIntent.self, provider: Provider()) { entry in
            JetChatWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct JetChatWidget_Previews: PreviewProvider {
    static var previews: some View {
        JetChatWidgetEntryView(entry: SimpleEntry(date: Date(), object: "", configuration: FYConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct WidgetMsgItem: Codable {
    /// 聊天会话id
    var chatId: Int?
    /// 用户名
    var name: String = ""
    /// 最近消息
    var message: String = ""
    /// 消息发送时间
    var date: String = ""
    /// 昵称备注名称
    var nickName: String? = ""
}
