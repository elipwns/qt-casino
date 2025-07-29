#pragma once

#include <QObject>

class GameLogic : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(int playerChips READ playerChips NOTIFY playerChipsChanged)
    Q_PROPERTY(bool gameActive READ gameActive NOTIFY gameActiveChanged)
    Q_PROPERTY(int selectedBetAmount READ selectedBetAmount NOTIFY selectedBetAmountChanged)
    Q_PROPERTY(QList<int> availableBetAmounts READ availableBetAmounts NOTIFY availableBetAmountsChanged)
    Q_PROPERTY(int passLineBet READ passLineBet NOTIFY passLineBetChanged)
    Q_PROPERTY(int dontPassBet READ dontPassBet NOTIFY dontPassBetChanged)
    Q_PROPERTY(int point READ point NOTIFY pointChanged)
    Q_PROPERTY(QString gamePhase READ gamePhase NOTIFY gamePhaseChanged)
    Q_PROPERTY(QString lastResult READ lastResult NOTIFY lastResultChanged)
    
public:
    explicit GameLogic(QObject *parent = nullptr);
    
    int playerChips() const { return m_playerChips; }
    bool gameActive() const { return m_gameActive; }
    int selectedBetAmount() const { return m_selectedBetAmount; }
    QList<int> availableBetAmounts() const { return m_availableBetAmounts; }
    int passLineBet() const { return m_passLineBet; }
    int dontPassBet() const { return m_dontPassBet; }
    int point() const { return m_point; }
    QString gamePhase() const { return m_gamePhase; }
    QString lastResult() const { return m_lastResult; }
    
public slots:
    void rollDice();
    void placeBet(const QString& betType);
    void setSelectedBetAmount(int amount);
    
signals:
    void playerChipsChanged();
    void gameActiveChanged();
    void selectedBetAmountChanged();
    void availableBetAmountsChanged();
    void passLineBetChanged();
    void dontPassBetChanged();
    void pointChanged();
    void gamePhaseChanged();
    void lastResultChanged();
    void diceRolled(int die1, int die2);
    void betError(const QString& message);
    
private:
    void updateAvailableBetAmounts();
    void handleComeOutRoll(int total);
    void handlePointRoll(int total);
    void payoutPassLine(bool win);
    void payoutDontPass(bool win);
    void resetGame();
    
    int m_playerChips = 1000;
    bool m_gameActive = false;
    int m_selectedBetAmount = 5;
    QList<int> m_availableBetAmounts = {5, 10, 25, 50, 100};
    int m_passLineBet = 0;
    int m_dontPassBet = 0;
    int m_point = 0;
    QString m_gamePhase = "Come Out";
    QString m_lastResult = "";
};