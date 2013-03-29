#ifndef SHOWI2PADDRESSES_H
#define SHOWI2PADDRESSES_H

#include <QDialog>

namespace Ui {
class ShowI2PAddresses;
}

class ShowI2PAddresses : public QDialog
{
    Q_OBJECT
    
public:
    explicit ShowI2PAddresses(QWidget *parent = 0);
    ~ShowI2PAddresses();
    
private:
    Ui::ShowI2PAddresses *ui;
};

#endif // SHOWI2PADDRESSES_H
