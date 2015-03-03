//
//  ViewController.m
//  Rest
//
//  Created by Habil on 04/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

#import "ViewController.h"
#import "DetalleUsuarioSeleccionado.h"

@interface ViewController ()
{
    NSMutableArray *cedulasRecuperadas;
    NSDictionary *diccionarioCedulas;
    
    NSString *nombreTitulo;
    NSString *numeroCedula;
    NSString *nombreEscuela;
    NSString *nombreCompleto;
    NSString *nombreGenero;
    NSString *anioExpedicion;
    NSString *tipoCedula;
}
@end

@implementation ViewController
@synthesize nombre;
@synthesize paterno;
@synthesize materno;
@synthesize anioIni;
@synthesize anioFin;
@synthesize idCedula;

- (IBAction)buscarCedulasProfesionales;
{
#define AS(A,B)    [(A) stringByAppendingString:(B)]
    
    
    NSString *nombreUrl    = @"";
    NSString *apPaternoUrl = @"";
    NSString *apMaternoUrl = @"";
    NSString *cedula       = @"";
    NSString *anioInicio   = @"";
    NSString *anioFinal    = @"";
    NSString *codSexo      = @"";
    
    {//SE OBTIENE LA INFORMACIÓN DEL FORMULARIO PARA LLENAR LAS VARIABLES Y FORMAR CON ESTAS LA URL DE PETICIÓN.
        nombreUrl    =  [self.nombre.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
        apPaternoUrl =  [self.paterno.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
        apMaternoUrl =  [self.materno.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
        cedula       =  [self.idCedula.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
        anioInicio   =  [self.anioIni.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
        anioFinal      =  [self.anioFin.text stringByAddingPercentEscapesUsingEncoding:
                           NSUTF8StringEncoding];
        codSexo      =  [self.hiddenSexo.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
    }
    
    {//LIMPIAR TABLE VIEW DE INFORMACIÓN
        [cedulasRecuperadas removeAllObjects];
        [self.tableData reloadData];
    }
    
    
    NSLog(@"URL PARAMETROS RECUPERADOS:%@ - %@", self.nombre.text, apMaternoUrl);
    
    if(![nombreUrl isEqualToString:@""] && ![apPaternoUrl isEqualToString:@""]){
        
        //SETEO DE VALORES A LOS PARAMETROS DE JSON PARA RECUPERAR EL RESPONSE CON LA INFORMACION ENCONTRADA.
        NSString *url1 = @"http://www.cedulaprofesional.sep.gob.mx/cedula/buscaCedulaJson.action?json=%7B%22maxResult%22%3A%221000%22%2C%22idCedula%22%3A%22%22%2C%22terminos%22%3A%22false%22%2C%22nombre%22%3A%22";
        
        NSString *url2 = @"%22%2C%22paterno%22%3A%22";
        
        NSString *url3 = @"%22%2C%22materno%22%3A%22";
        
        NSString *url4 = @"%22%2C%22h_genero%22%3A%22";
        
        NSString *url5 = @"%22%2C%22genero%22%3A%22%22%2C%22annioInit%22%3A%22";
        
        NSString *url6 = @"%22%2C%22annioEnd%22%3A%22";
        
        NSString *url7 = @"%22%2C%22insedo%22%3A%22%22%2C%22inscons%22%3A%22%22%2C%22institucion%22%3A%22TODAS%22%2C%22condiciones%22%3A%22false%22%7D";
        
        NSLog(@"URL FINAL:%@ - %@", nombreUrl, apMaternoUrl);
        
        NSLog(@"SEXO DE LA PERSONA SOLICITADA:%@", codSexo);
        
        //SE VALIDA EL SEXO SELECCIONADO EN EL RADIO BUTTON Y SE SETEA EL VALOR QUE ESPERA EL JSON.
        if ([codSexo isEqualToString:@"%20Mujer"]) {
            codSexo = @"2";
        } else if ([codSexo isEqualToString:@"%20Hombre"]) {
            codSexo = @"1";
        } else if ([codSexo isEqualToString:@"%20Todos"]) {
            codSexo = @"";
        } else {
            codSexo = @"";
        }
        
        //SE CONCATENAN LAS URLS PARA FORMAR LA PETICIÓN
        NSString *urlString = AS(url1, nombreUrl);
        urlString = AS(urlString, url2);
        urlString = AS(urlString, apPaternoUrl);
        urlString = AS(urlString, url3);
        urlString = AS(urlString, apMaternoUrl);
        urlString = AS(urlString, url4);
        urlString = AS(urlString, codSexo);
        urlString = AS(urlString, url5);
        urlString = AS(urlString, anioInicio);
        urlString = AS(urlString, url6);
        urlString = AS(urlString, anioFinal);
        urlString = AS(urlString, url7);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"URL FINAL:%@", url);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSLog(@"URL REQUEST: %@", request);
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             NSLog(@"URL RESPONSE: %@", response);
             if (data.length > 0 && connectionError == nil)
             {
                 
                 NSError *error2;
                 NSString *string = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&error2];
                 NSData *utf8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
                 id jsonObject  = [NSJSONSerialization JSONObjectWithData:utf8Data options:kNilOptions error:&error2];
                 
                 if (error2) {
                     NSLog(@"Error: %@", error2);
                 } else {
                     NSLog(@"OBTENCION DATOS CEDULAS #########: %@", jsonObject) ;
                     NSArray *cedulas = [jsonObject objectForKey:@"items"];
                     NSLog(@"INFORMACIÓN RECUPERADA: %@", cedulas) ;
                     NSLog(@"EL NUMERO DE REGISTROS ENCONTRADOS FUE DE: %lu", (unsigned long)[ cedulas count ]) ;
                     
                     if (cedulas && [ cedulas count ] > 0) {
                         NSLog(@"RECUPERANDO INFORMACIÓN") ;
                         
                         {//LLENAR INFORMACIÓN EN EL TABLE VIEW
                             nombreTitulo     = @"titulo";
                             numeroCedula     = @"idCedula";
                             nombreEscuela    = @"desins";
                             nombreCompleto   = @"nombre";
                             nombreGenero     = @"sexo";
                             anioExpedicion   = @"anioreg";
                             tipoCedula       = @"tipo";
                             
                             cedulasRecuperadas = [[NSMutableArray alloc] init];
                             
                             for (NSDictionary *dataDict in cedulas) {
                                 
                                 NSString *tempNombreTitulo   = [dataDict objectForKey:@"titulo"];
                                 NSString *tempNumeroCedula   = [dataDict objectForKey:@"idCedula"];
                                 NSString *tempNombreEscuela  = [dataDict objectForKey:@"desins"];
                                 
                                 NSString *tempNombreCompleto = [dataDict objectForKey:@"nombre"];
                                 NSString *tempNombreGenero   = [dataDict objectForKey:@"sexo"];
                                 NSString *tempAnioExpedicion = [dataDict objectForKey:@"anioreg"];
                                 NSString *tempTipoCedula     = [dataDict objectForKey:@"tipo"];
                                 
                                 NSLog(@"TITULO: %@",tempNombreTitulo);
                                 NSLog(@"CEDULA: %@",tempNumeroCedula);
                                 NSLog(@"DESINS: %@",tempNombreEscuela);
                                 NSLog(@"ANIO REGISTRO: %@",tempAnioExpedicion);
                                 
                                 diccionarioCedulas = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       tempNombreTitulo,   nombreTitulo,
                                                       tempNumeroCedula,   numeroCedula,
                                                       tempNombreEscuela,  nombreEscuela,
                                                       tempNombreCompleto, nombreCompleto,
                                                       tempNombreGenero,   nombreGenero,
                                                       tempAnioExpedicion, anioExpedicion,
                                                       tempTipoCedula,     tipoCedula,
                                                       nil];
                                 [cedulasRecuperadas addObject:diccionarioCedulas];
                                 
                             }
                             
                             [self.tableData reloadData];
                         }
                     }
                     
                 }
                 
             }
         }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Captura: %@",self.nombre.text);
    [self.nombre resignFirstResponder];
    return YES;
}

@synthesize Todos;
@synthesize Hombre;
@synthesize Mujer;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buscarCedulasProfesionales];
    
    {//FORMAR LA APARIENCIA DEL RADIO BUTTON AL MOMENTO DE CARGAR LA PANTALLA.
        Todos.layer.cornerRadius=22;
        Todos.layer.masksToBounds=YES;
        Todos.tag=1;
        [Todos addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        Hombre.layer.cornerRadius=22;
        Hombre.layer.masksToBounds=YES;
        Hombre.tag=2;
        [Hombre addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        Mujer.layer.cornerRadius=22;
        Mujer.layer.masksToBounds=YES;
        Mujer.tag=3;
        [Mujer addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//METODO QUE PERMITE EL MOVIMIENTO ENTRE RADIO BUTTONS PARA CAUSAR EL EFECTO DE SELECCIONADO, OBTIENE EL VALOR DEL TAG SELECCIONADO.
- (void)radioButtonClicked:(UIButton *)sender{
    switch(sender.tag){
        case 1:
            //SE SETEA A UN LABEL HIDDEN EL VALOR DEL RADIO BUTTON SELECCIOANDO.
            _hiddenSexo.text = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
            
            if([Todos isSelected] == YES){
                [Todos setSelected:NO];
                
                [Todos setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Hombre setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Mujer setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                
            } else {
                [Todos  setSelected : YES];
                [Hombre setSelected : NO];
                [Mujer  setSelected : NO];
                
                [Todos setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Hombre setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Mujer setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
            //SE SETEA A UN LABEL HIDDEN EL VALOR DEL RADIO BUTTON SELECCIOANDO.
            _hiddenSexo.text = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
            
            if([Hombre isSelected] == YES){
                [Hombre setSelected : NO];
                [Hombre setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Todos setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Mujer setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                
            } else {
                [Hombre setSelected : YES];
                [Todos  setSelected : NO];
                [Mujer  setSelected : NO];
                
                [Hombre setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Todos setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Mujer setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            //SE SETEA A UN LABEL HIDDEN EL VALOR DEL RADIO BUTTON SELECCIOANDO.
            _hiddenSexo.text = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
            
            if([Mujer isSelected] == YES){
                [Mujer setSelected : NO];
                
                [Mujer setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Todos setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Hombre setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                
            } else {
                [Mujer  setSelected : YES];
                [Todos  setSelected : NO];
                [Hombre setSelected : NO];
                
                [Mujer setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                [Todos setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                [Hombre setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cedulasRecuperadas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:
              UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *tmpDict = [cedulasRecuperadas objectAtIndex:indexPath.row];
    
    NSMutableString *text;
    
    text = [NSMutableString stringWithFormat:@"%@",
            [tmpDict objectForKeyedSubscript:nombreTitulo]];
    
    NSMutableString *detail;
    detail = [NSMutableString stringWithFormat:@"Escuela: %@ ",
              [tmpDict objectForKey:nombreEscuela]];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text= detail;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    {//CELDA DEL TABLE VIEW SELECCIONADA.
        DetalleUsuarioSeleccionado *detalleUsuarioSeleccionado = [[DetalleUsuarioSeleccionado alloc] initWithNibName:NSStringFromClass([DetalleUsuarioSeleccionado class]) bundle:nil];
        self.navigationItem.title = @"";
        [self.navigationController pushViewController:detalleUsuarioSeleccionado animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableData indexPathForSelectedRow];
    DetalleUsuarioSeleccionado *detalleUsuarioSeleccionado = (DetalleUsuarioSeleccionado *)segue.destinationViewController;
    detalleUsuarioSeleccionado.detalleUsuarioSeleccionado = [cedulasRecuperadas objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
