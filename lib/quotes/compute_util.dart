
double ComputeGainsRate(double yesterday_close,double current_prices,double today_open){
  double result;
  if(current_prices==0){
    result=0.0;
  }else{
    if(yesterday_close!=0){
      result=(current_prices-yesterday_close)/yesterday_close;
    }else{
      if(today_open!=0){
        result=(current_prices-today_open)/today_open;
      }else{
        result=0.0;
      }
    }
  }
  return result;
}

String ComputeGainsNum(double yesterday_close,double current_prices,double today_open){
  String gains_num;
  if (current_prices == 0) {
    gains_num = "0.00";
  } else {
    if (yesterday_close != 0) {
      gains_num = (current_prices - yesterday_close).toStringAsFixed(2);
    } else {
      if (today_open != 0) {
        gains_num = (current_prices - today_open).toStringAsFixed(2);
      } else {
        gains_num = "0.00";
      }
    }
  }
  return gains_num;
}