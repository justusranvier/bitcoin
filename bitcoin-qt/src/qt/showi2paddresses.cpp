#include "src/qt/showi2paddresses.h"
#include "ui_showi2paddresses.h"

ShowI2PAddresses::ShowI2PAddresses(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ShowI2PAddresses)
{
    ui->setupUi(this);
}

ShowI2PAddresses::~ShowI2PAddresses()
{
    delete ui;
}
