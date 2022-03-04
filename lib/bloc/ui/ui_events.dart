import 'package:equatable/equatable.dart';

class UiEvent extends Equatable {
  const UiEvent();

  @override
  List<Object?> get props => [];
}


class UiSttInitialize extends UiEvent{

}

class UiSttChangeStatus extends UiEvent {
  String status;
  UiSttChangeStatus({
    required this.status,
  });
}

class UiSttErrorOccurs extends UiEvent {
  String message;
  UiSttErrorOccurs({
    required this.message,
  });

}

class UiSttStop extends UiEvent{
  
}

class UiSttToggleInput extends UiEvent{
  
}