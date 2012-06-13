// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle{
    id: rectangle1
    width: 800
    height: 500
    state: "main"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#22c82f";
        }
        GradientStop {
            position: 0.99;
            color: "#c5a8c6";
        }
    }

    function enterDate()
    {
        if(text_edit1.text=="")
        {
            return true
        }
        else
        {
            return false
        }
    }

    function enterDateAdd()
    {
        if(text_edit1.text=="")
        {
            return true
        }
        else
        {
            return false
        }
    }



    function dbDelete() {
        var db = openDatabaseSync("QDeclarativeExampleDB", "1.0", "The Example QML SQL!", 1000000);

        db.transaction(
                    function(tx) {
                        var rs=tx.executeSql("delete from note where date= ?",[text_edit1.text]);
                    }
                    )
    }
    function dbAdd() {
        var db = openDatabaseSync("QDeclarativeExampleDB", "1.0", "The Example QML SQL!", 1000000);

        db.transaction(
                    function(tx) {
                        // Create the database if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS [note] ([id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                                      '[date] INTEGER NOT NULL,'+
                                      '[textnote] TEXT  NULL);');

                        // Add (another) greeting row
                        text_edit4.text= ' '+ text_edit4.text+ '\rKomment: ' + text_edit7.text+ '\r\r';
                        tx.executeSql("insert into note ('date', 'textnote') values ("+text_edit1.text+" , '"+ text_edit4.text+"');");
                    }
                    )
    }

    function dbShow() {
        var db = openDatabaseSync("QDeclarativeExampleDB", "1.0", "The Example QML SQL!", 1000000);

       db.transaction(
                    function(tx) {

                        // Show all added greetings
                       var rs = tx.executeSql('SELECT * FROM note');

                        var r = ""
                        for(var i = 0; i < rs.rows.length; i++) {
                            r += i+" "+rs.rows.item(i).id + ", " + rs.rows.item(i).date + ", " + rs.rows.item(i).text  + "\n"
                        }
                        txt.text = r
                    }
                    )
    }






    Rectangle {
        id: column1
        x: 0
        y: 0
        width: rectangle1.width
        height: 220

        Rectangle {
            id: rectangle10
            x: 0
            y: 0
            width: rectangle1.width*300/800
            height:rectangle1.height*375/500
            border.width: 2
            border.color: "#000000"
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#090000"
                }

                GradientStop {
                    position: 0.090
                    color: "#fd0606"
                }

                GradientStop {
                    position: 0.520
                    color: "#ffffff"
                }

                GradientStop {
                    position: 0.810
                    color: "#f30808"
                }

                GradientStop {
                    position: 1
                    color: "#0d0000"
                }
            }

            Component {
                id: petDelegate

                Item {
                    id: wrapper
                    x:10
                    width: 200; height: 150


                    Rectangle{
                        id:rect12
                        width: rectangle10.width-100
                        height: wrapper.height-2
                        radius: 18
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#b2fb9e"
                            }

                            GradientStop {
                                position: 0.830
                                color: "#47f906"
                            }

                            GradientStop {
                                position: 1
                                color: "#000000"
                            }
                        }
                        opacity: 1



                    Column {
                        x: 5
                        y: 15
                      //  Text { text: ' Date: ' + date +'      |||     Note: ' + textnote }
                      //Text { text: '#: ' + id }
                        Text { text: 'Date: ' + date }
                        Text { text: 'Note: ' + textnote }

                    }
                    }//// rectangle



                    Rectangle{
                        id:deletezap
                        x:rectangle10.width-90
                        y:60
                        width: 60
                        height: 33
                        radius: 10
                        border.width: 2
                        border.color: "#000000"
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#2efb04"
                            }

                            GradientStop {
                                position: 1
                                color: "#fbec0c"
                            }
                        }
                        smooth: true
                        Text { color: "#0d0d00"; text: "   delete \r \n  " + date ; style: Text.Normal; font.underline: false; opacity: 1; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter;font.pointSize: 10 }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onEntered: parent.border.color = Qt.lighter("#6A6D6A")
                            onExited:  parent.border.color = "#6A6D6A"
                            onClicked: {
                                text_edit1.text=date
                                dbDelete()
                                text_edit1.text=""
                                rectangle1.state = "show"
                                listModel.clear()
                                listView.dbshow()




                        }
                        }

                    }


                }
            }




            ListView {
                id: listView
                x: 0
                y: 40
                width: rectangle10.width
                height:rectangle1.height*350/800

                model: ListModel {
                    id: listModel
                }
                delegate: petDelegate
                focus: true

                // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
                // to false so the highlight delegate can control how the highlight is moved.
                highlight: highlightBar
                highlightFollowsCurrentItem: false

                function dbshow()
                {
                    var db = openDatabaseSync("QDeclarativeExampleDB", "1.0", "The Example QML SQL!", 1000000);
                    db.transaction(
                                function(tx) {

                                    // Show all added greetings
                                    var rs = tx.executeSql('SELECT * FROM note');
                                    for(var i = 0; i < rs.rows.length; i++) {
                                        var data = {'id':rs.rows.item(i).id, 'date': rs.rows.item(i).date, 'textnote': rs.rows.item(i).textnote};
                                        listModel.append(data)

                                    }
                                    listModel.sync()
                                }
                                )
                }

                Component.onCompleted: {
                    dbshow()
                }
            }
            Rectangle {
                id: rectangle6   ////текстовик
                x: rectangle1.width*300/800
                y: 0


                width: rectangle1.width*500/800
                height:rectangle1.height* 200/500
                radius: 0
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#0d0000"
                    }

                    GradientStop {
                        position: 0.170
                        color: "#f90404"
                    }

                    GradientStop {
                        position: 0.970
                        color: "#ffffff"
                    }

                    GradientStop {
                        position: 0.980
                        color: "#ffffff"
                    }
                }
                border.width: 0
                border.color: "#f0f70a"
                smooth: false
                opacity: 1
                clip: false

                TextEdit {
                    id: text_edit4
                    x: 70
                    y: 40
                    width: rectangle1.width*400/800
                    height: rectangle1.height*110/500
                    text: ""
                    textFormat: TextEdit.AutoText
                    wrapMode: TextEdit.WrapAnywhere
                    font.family: "Arial Black"
                    clip: false
                    activeFocusOnPress: true
                    opacity: 1
                    horizontalAlignment: TextEdit.AlignLeft
                    font.pixelSize: 20

                    Text {
                        id: text4
                        x: -56
                        y: 0
                        text: qsTr("Sobitie")
                        font.pixelSize: 12
                    }
                }

            }
            Rectangle {
                id: rectangle7
                x: rectangle1.width*300/800
                y: rectangle1.height* 200/500

                width:rectangle1.width* 499/800
                height:rectangle1.height*176/500
                radius: 0
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#ffffff"
                    }

                    GradientStop {
                        position: 0.580
                        color: "#f90a0a"
                    }

                    GradientStop {
                        position: 1
                        color: "#000000"
                    }
                }
                smooth: false
                opacity: 1
                clip: false

                TextEdit {
                    id: text_edit7
                    x: 70
                    y: 40
                    width: rectangle1.width*400/800
                    height: rectangle1.height* 100/500
                    text: ""
                    scale: 1
                    textFormat: TextEdit.AutoText
                    clip: true
                    rotation: 0
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    cursorVisible: false
                    horizontalAlignment: TextEdit.AlignLeft
                    font.pixelSize: 24
                }
            }
        }

    }

    Text {
        id: text2
        x:rectangle1.width* 310/800
        y: rectangle1.height*207/500
        width: 58
        height: 33
        text: qsTr("Komment")
        font.pixelSize: 12
    }
    Rectangle {
        id: column2
        x: 0
        y: rectangle1.height*375/500
        width: rectangle1.width
        height: rectangle1.height*138/500
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#090000"
            }

            GradientStop {
                position: 0.980
                color: "#348206"

            }

            GradientStop {
                position: 0.990
                color: "#c5a8c6"
            }
        }




        Button {
            id: addnote
            x: rectangle1.width* 126/800
            y :column2.height* 40/137
            anchors.centerIn: parent
            text: "Add note"
            anchors.verticalCenterOffset: -4
            anchors.horizontalCenterOffset: -224
            onClicked: {

                if(enterDateAdd())
                {

                }
                else
                {
                    dbAdd()
                    text_edit1.text=""
                    text_edit4.text=""
                    text_edit7.text=""
                }
                rectangle1.state = "show"
                listModel.clear()
                listView.dbshow()
            }

        }
        Text {
            id: text1
            x: rectangle1.width*406/800
            y: column2.height*42/137
            text: qsTr("Enter date   :")
            font.pixelSize: 15
            color: "white"
        }
        Button{
            id: buttonDelByDate
            x:247
            y:40
            width: 144
            height: 50
            anchors.centerIn: parent
            text:"Delete"
            anchors.verticalCenterOffset: -4
            anchors.horizontalCenterOffset: -81
            onClicked: {
                if(enterDate())
                {

                }
                else
                {
                    dbDelete()
                    text_edit1.text=""
                }
                rectangle1.state = "show"
                listModel.clear()
                listView.dbshow()
                }
        }

Rectangle {
        id: rectangle2
        x: rectangle1.width*406/800
        y: column2.height*60/137
            width:rectangle1.width* 100/800
            height: 20
            color: "#ffffff"

            TextEdit {
                id: text_edit1
                x: 0
                y: 0
                width: rectangle2.width
                height: rectangle2.height
                font.pixelSize: 15
            }
}

Text {
    id: text3
    x: rectangle1.width*563/800
    y: column2.height*42/137


    text: qsTr("Current date:")
    color: "white"
    font.pixelSize: 15
}

TextEdit {
    id: text_edit5

    x: rectangle1.width*563/800
    y: column2.height*60/137
    width: rectangle1.width* 100/800
    height: 20
    text: Qt.formatDateTime(new Date(), "dd.MM.yy")
    readOnly: true
    font.pixelSize: 15
    color: "red"
}
    }


}
