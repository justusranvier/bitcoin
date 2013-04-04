#ifndef I2POPTIONSWIDGET_H
#define I2POPTIONSWIDGET_H

#include <QWidget>

namespace Ui {
class I2POptionsWidget;
}

class I2POptionsWidget : public QWidget
{
    Q_OBJECT
    
public:
    explicit I2POptionsWidget(QWidget *parent = 0);
    ~I2POptionsWidget();
    
private:
    Ui::I2POptionsWidget *ui;
};

#endif // I2POPTIONSWIDGET_H
