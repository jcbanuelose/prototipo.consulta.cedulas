//
//  ViewController.m
//  Rest
//
//  Created by Habil on 04/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

#import "ViewController2.h"
#import "DetalleUsuarioSeleccionado.h"

@interface ViewController2 ()
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

@implementation ViewController2
@synthesize idCedula;

- (IBAction)buscarCedulasProfesionales;
{
#define AS(A,B)    [(A) stringByAppendingString:(B)]
    
    NSString *cedula       = @"";
    
    {//SE OBTIENE LA INFORMACIÓN DEL FORMULARIO PARA LLENAR LAS VARIABLES Y FORMAR CON ESTAS LA URL DE PETICIÓN.
        cedula       =  [self.idCedula.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];
    }
    
    {//LIMPIAR TABLE VIEW DE INFORMACIÓN
        [cedulasRecuperadas removeAllObjects];
        [self.tableData reloadData];
    }
    
    NSLog(@"CEDULA :%@", cedula);
    
    if(![cedula isEqualToString:@""]){
        
        //SETEO DE VALORES A LOS PARAMETROS DE JSON PARA RECUPERAR EL RESPONSE CON LA INFORMACION ENCONTRADA.
        
        NSString *url1 = @"http://www.cedulaprofesional.sep.gob.mx/cedula/buscaCedulaJson.action?json=%7B%22maxResult%22:%221000%22%2C%22idCedula%22:%22";
        
        NSString *url2 = @"%22,%22nombre%22:%22%22,%22paterno%22:%22%22,%22materno%22:%22%22,%22h_genero%22:%22%22,%22genero%22:%22%22,%22annioInit%22:%22%22,%22annioEnd%22:%22%22,%22insedo%22:%22%22,%22inscons%22:%22%22,%22institucion%22:%22TODAS%22%7D";
        
        
        //SE CONCATENAN LAS URLS PARA FORMAR LA PETICIÓN
        NSString *urlString = AS(url1, cedula);
        urlString = AS(urlString, url2);
        
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
    NSLog(@"Captura: %@",self.idCedula.text);
    [self.idCedula resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buscarCedulasProfesionales];
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
