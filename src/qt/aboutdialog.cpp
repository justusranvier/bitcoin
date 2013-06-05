//
// I2P-patch
// Copyright (c) 2012-2013 giv
#include "aboutdialog.h"
#include "ui_aboutdialog.h"

#include "clientmodel.h"

// Copyright year (2009-this)
// Todo: update this when changing our copyright comments in the source
const int ABOUTDIALOG_COPYRIGHT_YEAR = 2013;

AboutDialog::AboutDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AboutDialog)
{
    ui->setupUi(this);

    // Set current copyright year
    ui->copyrightLabel->setText(tr("Copyright") + QString(" &copy; ") + tr("2009-%1 The Bitcoin developers").arg(ABOUTDIALOG_COPYRIGHT_YEAR));
}

void AboutDialog::setModel(ClientModel *model)
{
    if(model)
    {
        ui->versionLabel->setText(model->formatFullVersion());

#ifdef USE_NATIVE_I2P
        ui->i2pNativeVersionLabel->setText(model->formatI2PNativeFullVersion());
#endif
    }
}

AboutDialog::~AboutDialog()
{
    delete ui;
}

void AboutDialog::on_buttonBox_accepted()
{
    close();
}
