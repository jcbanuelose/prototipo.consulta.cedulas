//
//  ViewController.h
//  prototipo.consulta.cedulas
//
//  Created by Habil on 04/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2 :  UIViewController<UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *nombre;
@property (nonatomic, strong) IBOutlet UITextField *paterno;
@property (nonatomic, strong) IBOutlet UITextField *materno;
@property (nonatomic, strong) IBOutlet UITextField *anioIni;
@property (nonatomic, strong) IBOutlet UITextField *anioFin;
@property (nonatomic, strong) IBOutlet UITextField *desins;
@property (nonatomic, strong) IBOutlet UITextField *idCedula;
@property (nonatomic, strong) IBOutlet UITextField *inscons;
@property (nonatomic, strong) IBOutlet UITextField *insedo;
@property (nonatomic, strong) IBOutlet UITextField *tipo;
@property (nonatomic, strong) IBOutlet UITextField *titulo;
@property (nonatomic, strong) IBOutlet UILabel     *hiddenSexo;
@property (nonatomic, strong) IBOutlet UIButton * Todos;
@property (nonatomic, strong) IBOutlet UIButton * Hombre;
@property (nonatomic, strong) IBOutlet UIButton * Mujer;
@property (nonatomic, strong) IBOutlet UITableView *tableData;

- (IBAction)buscarCedulasProfesionales;

@end