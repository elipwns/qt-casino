#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
#include "gamelogic.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    // Set application icon
    QIcon icon(":/icon.ico");
    if (!icon.isNull()) {
        app.setWindowIcon(icon);
        qDebug() << "Icon loaded successfully";
    } else {
        qDebug() << "Failed to load icon from :/icon.ico";
    }
    
    qmlRegisterType<GameLogic>("QtCasino", 1, 0, "GameLogic");
    
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}