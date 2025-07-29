#include "gamelogic.h"
#include <QRandomGenerator>
#include <QDebug>

GameLogic::GameLogic(QObject *parent)
    : QObject(parent)
{
    updateAvailableBetAmounts();
}

void GameLogic::rollDice()
{
    int die1 = QRandomGenerator::global()->bounded(1, 7);
    int die2 = QRandomGenerator::global()->bounded(1, 7);
    int total = die1 + die2;
    
    emit diceRolled(die1, die2);
    
    // Process craps rules
    if (m_gamePhase == "Come Out") {
        handleComeOutRoll(total);
    } else if (m_gamePhase == "Point") {
        handlePointRoll(total);
    }
}

void GameLogic::placeBet(const QString& betType)
{
    if (m_selectedBetAmount > m_playerChips) {
        emit betError("Not enough chips!");
        return;
    }
    
    if (betType == "Pass Line") {
        if (m_dontPassBet > 0) {
            emit betError("Cannot bet Pass Line when you have Don't Pass bet!");
            return;
        }
        m_passLineBet += m_selectedBetAmount;
        emit passLineBetChanged();
    }
    else if (betType == "Don't Pass") {
        if (m_passLineBet > 0) {
            emit betError("Cannot bet Don't Pass when you have Pass Line bet!");
            return;
        }
        m_dontPassBet += m_selectedBetAmount;
        emit dontPassBetChanged();
    }
    
    m_playerChips -= m_selectedBetAmount;
    emit playerChipsChanged();
    updateAvailableBetAmounts();
    
    qDebug() << "Placed" << m_selectedBetAmount << "bet on" << betType;
}

void GameLogic::setSelectedBetAmount(int amount)
{
    if (m_selectedBetAmount != amount && m_availableBetAmounts.contains(amount)) {
        m_selectedBetAmount = amount;
        emit selectedBetAmountChanged();
    }
}

void GameLogic::handleComeOutRoll(int total)
{
    if (total == 7 || total == 11) {
        // Pass Line wins, Don't Pass loses
        m_lastResult = "Natural " + QString::number(total) + " - Pass Line wins!";
        payoutPassLine(true);
        payoutDontPass(false);
    }
    else if (total == 2 || total == 3 || total == 12) {
        // Craps - Pass Line loses, Don't Pass wins (except 12 is push for Don't Pass)
        if (total == 12) {
            m_lastResult = "Craps 12 - Pass Line loses, Don't Pass pushes";
            payoutPassLine(false);
            // Don't Pass pushes (no win/loss)
        } else {
            m_lastResult = "Craps " + QString::number(total) + " - Don't Pass wins!";
            payoutPassLine(false);
            payoutDontPass(true);
        }
    }
    else {
        // Point established (4, 5, 6, 8, 9, 10)
        m_point = total;
        m_gamePhase = "Point";
        m_lastResult = "Point " + QString::number(total) + " established";
        emit pointChanged();
        emit gamePhaseChanged();
    }
    emit lastResultChanged();
}

void GameLogic::handlePointRoll(int total)
{
    if (total == m_point) {
        // Point made - Pass Line wins, Don't Pass loses
        m_lastResult = "Point " + QString::number(total) + " made - Pass Line wins!";
        payoutPassLine(true);
        payoutDontPass(false);
        resetGame();
    }
    else if (total == 7) {
        // Seven out - Pass Line loses, Don't Pass wins
        m_lastResult = "Seven out - Don't Pass wins!";
        payoutPassLine(false);
        payoutDontPass(true);
        resetGame();
    }
    else {
        // No decision, keep rolling
        m_lastResult = "Rolled " + QString::number(total) + " - keep rolling";
    }
    emit lastResultChanged();
}

void GameLogic::payoutPassLine(bool win)
{
    if (m_passLineBet > 0) {
        if (win) {
            m_playerChips += m_passLineBet * 2; // Return bet + winnings
        }
        m_passLineBet = 0;
        emit passLineBetChanged();
        emit playerChipsChanged();
        updateAvailableBetAmounts();
    }
}

void GameLogic::payoutDontPass(bool win)
{
    if (m_dontPassBet > 0) {
        if (win) {
            m_playerChips += m_dontPassBet * 2; // Return bet + winnings
        }
        m_dontPassBet = 0;
        emit dontPassBetChanged();
        emit playerChipsChanged();
        updateAvailableBetAmounts();
    }
}

void GameLogic::resetGame()
{
    m_point = 0;
    m_gamePhase = "Come Out";
    emit pointChanged();
    emit gamePhaseChanged();
}

void GameLogic::updateAvailableBetAmounts()
{
    // Standard $5 table progression, filtered by available chips
    QList<int> allAmounts = {5, 10, 25, 50, 100, 250, 500};
    QList<int> available;
    
    for (int amount : allAmounts) {
        if (amount <= m_playerChips) {
            available.append(amount);
        }
    }
    
    if (available != m_availableBetAmounts) {
        m_availableBetAmounts = available;
        emit availableBetAmountsChanged();
        
        // Adjust selected amount if it's no longer available
        if (!m_availableBetAmounts.contains(m_selectedBetAmount) && !m_availableBetAmounts.isEmpty()) {
            m_selectedBetAmount = m_availableBetAmounts.last(); // Largest affordable
            emit selectedBetAmountChanged();
        }
    }
}