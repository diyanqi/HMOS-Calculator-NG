// 数字键盘的公共样式
import { calculateByString } from 'calcByString'

@Extend(Button)
function numberBtn(num: number, click: (num: number) => void) {
  .type(ButtonType.Capsule)
  .width(60)
  .height(60)
  .onClick(() => click(num))
}

// 运算符公共样式
@Extend(Button)
function operatorBtn() {
  .type(ButtonType.Capsule)
  .backgroundColor(Color.Green)
  .width(60)
  .height(60)
}

// 额外功能公共样式
@Extend(Button)
function extraBtn() {
  .type(ButtonType.Capsule)
  .width(60)
  .height(60)
  .backgroundColor(Color.Red)
}

PersistentStorage.PersistProp('lastResult', '0');

@Entry
@Component
struct Index {
  @StorageProp('lastResult') message: string = '0'
  calcFinished: boolean = true;

  @Styles
  numberRow() {
    .width('100%')
    .margin({ bottom: 10 })
  }

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .width('100%')
          .textAlign(TextAlign.End)
      }
      .padding(10)
      .backgroundColor('gray')
      .borderWidth(1)
      .borderRadius(10)
      .margin(10)


      Row() {
        Button('7').numberBtn(7, this.onNumberClick)
        Button('8').numberBtn(8, this.onNumberClick)
        Button('9').numberBtn(9, this.onNumberClick)
        Button('重置').extraBtn().onClick(this.onResetClick)
      }
      .justifyContent(FlexAlign.SpaceAround)
      .numberRow()

      Row() {
        Button('4').numberBtn(4, this.onNumberClick)
        Button('5').numberBtn(5, this.onNumberClick)
        Button('6').numberBtn(6, this.onNumberClick)
        Button('删除').extraBtn().onClick(this.onDeleteClick)

      }
      .numberRow()
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('1').numberBtn(1, this.onNumberClick)
        Button('2').numberBtn(2, this.onNumberClick)
        Button('3').numberBtn(3, this.onNumberClick)
        Button('清理').extraBtn().onClick(this.onClearClick)
      }
      .numberRow()
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('%')
          .type(ButtonType.Capsule)
          .width(60)
          .height(60)
        Button('0').numberBtn(0, this.onNumberClick)
        Button('.')
          .type(ButtonType.Capsule)
          .width(60)
          .height(60)
          .onClick(this.onDotClick)
        Button('保存').operatorBtn().onClick(this.onSaveClick)
      }
      .numberRow()
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('x')
          .operatorBtn()
          .onClick(() => this.onOperatorClick('x'))
        Button('÷')
          .operatorBtn()
          .onClick(() => this.onOperatorClick('÷'))
        Button('+')
          .operatorBtn()
          .onClick(() => this.onOperatorClick('+'))
        Button('-')
          .operatorBtn()
          .onClick(() => this.onOperatorClick('-'))
      }
      .numberRow()
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('=')
          .width('100%')
          .backgroundColor(Color.Pink)
          .onClick(this.onCalcClick)
      }
      .margin(10)
    }
    .height('100%')
  }

  resetCheck() {
    if (this.calcFinished) {
      this.message = '0';
      this.calcFinished = false;
    }
  }

  onNumberClick = (num: number) => {
    this.resetCheck();
    if (this.message === '0') {
      this.message = `${num}`;
    } else {
      this.message += `${num}`
    }
  }
  onOperatorClick = (_opt: string) => {
    this.message += _opt;
    this.calcFinished = false;
  }
  onDotClick = () => {
    this.resetCheck();
    this.message += '.';
  }
  onResetClick = () => {
    this.message = '0';
    this.calcFinished = true;
  }
  onDeleteClick = () => {
    this.resetCheck();
    if (this.message.length > 1) {
      this.message = this.message.substr(0, this.message.length - 1);
    } else {
      this.message = '0'
    }
  }
  onSaveClick = () => {
    AppStorage.SetOrCreate('lastResult', this.message);
  }
  onClearClick = () => {
    PersistentStorage.DeleteProp('lastResult')
    this.message = '0';
  }
  onCalcClick = () => {
    this.message = calculateByString(this.message.replace(/x/g, '*').replace(/÷/g, '/')) + '';
    this.calcFinished = true;
  }
}