#include "i2poptionswidget.h"
#include "ui_i2poptionswidget.h"

I2POptionsWidget::I2POptionsWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::I2POptionsWidget)
{
    ui->setupUi(this);
}

I2POptionsWidget::~I2POptionsWidget()
{
    delete ui;
}
