#include "showi2paddresses.h"
#include "ui_showi2paddresses.h"

ShowI2PAddresses::ShowI2PAddresses(QWidget *parent/*, const QString& caption, const QString& pub, const QString& priv, const QString& b32, const QString& configFileName*/) :
    QDialog(parent),
    ui(new Ui::ShowI2PAddresses)
{
    ui->setupUi(this);
}

ShowI2PAddresses::~ShowI2PAddresses()
{
    delete ui;
}
